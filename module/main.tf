


module "vpc1" {
    source = "../vpc"

    region = var.region
    access_key = var.access_key
    secret_key = var.secret_key
    ami = var.ami
    instance_type = var.instance_type
    cidr_block = var.cidr_block
    public1-cidr_block = var.public1-cidr_block
    public1-az = var.public1-az
    private2-cidr_block = var.private2-cidr_block
    private2-az = var.private2-az
    bucket = var.bucket
    engine = var.engine
    instance_class = var.instance_class
    username = var.username
    password = var.password

}
