resource "aws_vpc" "vpc1" {
    cidr_block = "192.168.0.0/16"
    instance_tenancy = "default"
    tags = { 
        Name = "Terraform-vpc"
        env = "dev"
        Team = "DevOps"
    }
}

resource "aws_internet_gateway" "gwy1" {
    vpc_id = aws_vpc.vpc1.id 
}

#Public subnet 
resource "aws_subnet" "Public1"{
    availability_zone = "us-east-1a"
    cidr_block = "192.168.1.0/24"
    map_public_ip_on_launch = true
    vpc_id = aws_vpc.vpc1.id 
    tags ={
        Name = "Public-subnet-1"
    }
}

#Public subnet 
resource "aws_subnet" "Public2"{
    availability_zone = "us-east-1b"
    cidr_block = "192.168.2.0/24"
    map_public_ip_on_launch = true
    vpc_id = aws_vpc.vpc1.id 
    tags ={
        Name = "Public-subnet-2"
    }
}


#Private subnet
resource "aws_subnet" "Private1"{
    availability_zone = "us-east-1a"
    cidr_block = "192.168.3.0/24"
    vpc_id = aws_vpc.vpc1.id
    tags ={
        Name = "Private-subnet-1"
        env = "dev"
    }
}

resource "aws_subnet" "Private2"{
   availability_zone = "us-east-1b"
    cidr_block = "192.168.4.0/24"
    vpc_id = aws_vpc.vpc1.id
    tags ={
        Name = "Private-subnet-2"
        env = "dev"
    }
}

#Elastic Ip and NAT gateway_id --> elastic is a way when you shut down an instance to keep a consistent ip
resource "aws_eip" "eip" {
}

resource "aws_nat_gateway" "nat1"{
    allocation_id = aws_eip.eip.id 
    subnet_id = aws_subnet.Public2.id
}
#Public Route Table 
resource "aws_route_table" "rtpublic"{
    vpc_id = aws_vpc.vpc1.id
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gwy1.id
    }
}
#Private Route Table
resource "aws_route_table" "rtprivate1"{
    vpc_id = aws_vpc.vpc1.id
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id= aws_nat_gateway.nat1.id
    }
}
#Private Route Table
resource "aws_route_table" "rtprivate2"{
    vpc_id = aws_vpc.vpc1.id
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id= aws_nat_gateway.nat1.id
    }
}

#Private Subnet association 

resource "aws_route_table_association" "rta1"{
    subnet_id = aws_subnet.Private1.id
    route_table_id = aws_route_table.rtprivate1.id
}

resource "aws_route_table_association" "rta2"{
    subnet_id =aws_subnet.Private2.id
    route_table_id = aws_route_table.rtprivate2.id
}
#Public Subnet association 
resource "aws_route_table_association" "rta3"{
    subnet_id = aws_subnet.Public1.id
    route_table_id = aws_route_table.rtpublic.id
}

resource "aws_route_table_association" "rta4"{
    subnet_id =aws_subnet.Public2.id
    route_table_id = aws_route_table.rtpublic.id
}