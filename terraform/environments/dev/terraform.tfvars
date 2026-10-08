aws_region    = "ap-south-1"
environment   = "dev"
instance_type = "t3.large"

# apni public IP daalo (curl ifconfig.me), format: x.x.x.x/32
admin_cidr = "YOUR_PUBLIC_IP/32"

# web app sabko dikhani hai to 0.0.0.0/0, sirf tumhe to wahi admin_cidr
app_cidr = "0.0.0.0/0"
