 resource "aws_vpc" "myvpc" {
    cidr_block = var.cidr_block
    instance_tenancy = "default"
   
 }

 resource "aws_subnet" "public" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = var.public1-cidr_block
    availability_zone = var.public1-az
    map_public_ip_on_launch = true

 }

resource "aws_subnet" "private" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = var.private2-cidr_block
    availability_zone = var.private2-az
    map_public_ip_on_launch = true

 }



resource "aws_eip" "nat-eip" {
    domain = aws_vpc.myvpc
  
}

resource "aws_internet_gateway" "Igw" {
    vpc_id = aws_vpc.myvpc.id

  
}

resource "aws_nat_gateway" "nat-gw" {
    allocation_id = aws_eip.nat-eip
    subnet_id = aws_subnet.public.id

    depends_on = [ aws_vpc.myvpc ]
  
}

resource "aws_route_table" "public-rt" {
    vpc_id = aws_vpc.myvpc.id

route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Igw.id
}
  
}

resource "aws_route_table" "private-rt" {
    vpc_id = aws_vpc.myvpc.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat-gw.id
    }
  
}


resource "aws_route_table_association" "public-rta" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.public-rt.id

  }

  resource "aws_route_table_association" "private-rta" {
    subnet_id = aws_subnet.private.id
    route_table_id = aws_route_table.private-rt.id
    
  }

  resource "aws_default_security_group" "default" {
    vpc_id = aws_vpc.myvpc.id


    ingress {
        description = "vpc-sg"
        from_port = 0
        to_port = 0
        protocol = "tcp"
        cidr_blocks = ["${aws_vpc.myvpc.cidr_block}"]


    }
    

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
  }


resource "aws_s3_bucket" "mys3" {
    bucket = var.bucket
  
}

resource "aws_db_instance" "my_rds" {
  allocated_storage    = 10
  engine              = var.engine
  instance_class      = var.instance_class
  username            = var.username
  password            = var.password
  skip_final_snapshot = true
}
