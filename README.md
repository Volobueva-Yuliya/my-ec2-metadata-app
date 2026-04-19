# EC2 Metadata Web Application

Simple web application that returns EC2 instance metadata (region and availability zone).  
Designed for deployment on AWS using EC2, AMI, Auto Scaling Group, and Application Load Balancer.

---

## Features

- Returns EC2 region and availability zone
- Uses EC2 Metadata API (IMDSv2)
- Packaged as deployable artifact (.tar.gz)
- Runs on port 80
- Auto-start via systemd
- Scalable via Auto Scaling Group

---

## Example Response

```json
{
  "region": "us-east-1",
  "availabilityZone": "us-east-1a"
}

Project Structure
.
├── app/
│   └── main.py
├── scripts/
│   ├── build.sh
│   └── install.sh
├── requirements.txt
├── README.md