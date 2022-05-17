data "aws_ami" "amazon_ubuntu" {
  owners = ["099720109477"] # Canonical (Creators of Ubuntu)

  filter {
    name = "image-id"
    # AWS Marketplace - Canonical, Ubuntu, 20.04 LTS (Free tier)
    values = ["ami-02584c1c9d05efa69"]
  }
}

resource "aws_kms_key" "ghost" {
  description         = "${local.name}-kms-key"
  enable_key_rotation = true
  is_enabled          = true
  tags                = local.tags
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.9.0"

  name        = "${local.name}-sg"
  description = "Security group for ${local.name} application"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "ssh-tcp", "all-icmp"]

  egress_rules        = ["all-all"]

  tags = local.tags
}

resource "tls_private_key" "ghost" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ghost" {
  key_name   = "${local.name}-keypair"
  public_key = tls_private_key.ghost.public_key_openssh
}

module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.0.0"

  name = "${local.name}-ec2"

  ami                         = data.aws_ami.amazon_ubuntu.image_id
  instance_type               = var.ec2_instance_type
  key_name                    = aws_key_pair.ghost.key_name
  monitoring                  = true
  vpc_security_group_ids      = [module.security_group.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true

  user_data_base64            = base64encode(data.template_file.ghost_setup.rendered)
  user_data_replace_on_change = true

  enable_volume_tags = true

  ebs_block_device = [
    {
      device_name = "/dev/sda1"
      volume_type = "gp3"
      volume_size = 8
      throughput  = 125 
      encrypted   = true
      kms_key_id  = aws_kms_key.ghost.arn
    }
  ]

  tags = local.tags
}