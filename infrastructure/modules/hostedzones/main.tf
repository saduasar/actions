resource "aws_route53_zone" "private_zone" {
  name              = "asareinfo.xyz"  # Enter your desired domain name
  vpc {
    vpc_id = var.vpc_id  # Reference the VPC created above
  }
  tags = {
    Name        = var.tags["Name"]
    Project     = var.tags["Project"]
    Environment = var.tags["Environment"]  
  }
}

#resource "aws_route53_record" "webapp-record" {
 # zone_id = aws_route53_zone.private_zone.zone_id  # Reference the zone ID of the private hosted zone
 # name    = "app01.asareinfo.xyz"  # Enter your desired domain name
 # type    = "A"  # Example record type (e.g., A, CNAME, etc.)
 # ttl     = "300"
 # records = [var.webapp_private_ip]  # Example IP address
#}

resource "aws_route53_record" "db-record" {
  zone_id = aws_route53_zone.private_zone.zone_id  # Reference the zone ID of the private hosted zone
  name    = "db01.asareinfo.xyz"  # Enter your desired domain name
  type    = "CNAME"  # Example record type (e.g., A, CNAME, etc.)
  ttl     = "300"
  records = [var.rds-address-endpoint]  # Example IP address
}

resource "aws_route53_record" "mc-record" {
  zone_id = aws_route53_zone.private_zone.zone_id  # Reference the zone ID of the private hosted zone
  name    = "mcq01.asareinfo.xyz"  # Enter your desired domain name
  type    = "CNAME"  # Example record type (e.g., A, CNAME, etc.)
  ttl     = "300"
  records = [var.memcached-endpoint]  # Example IP address
}

resource "aws_route53_record" "rmq-record" {
  zone_id = aws_route53_zone.private_zone.zone_id  # Reference the zone ID of the private hosted zone
  name    = "rmq01.asareinfo.xyz"  # Enter your desired domain name
  type    = "CNAME"  # Example record type (e.g., A, CNAME, etc.)
  ttl     = "300"
  records = [var.rabbit-primary_console_url]  # Example IP address
}


