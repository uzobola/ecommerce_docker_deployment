### Steps to Jenkins EC2 in a Default VPC
- On the EC2 dashboard
- Click on "Launch Instance"
		Name and tags:
		Name: Jenkins
		Application and OS Images:
		Choose Ubuntu AMI (free tier eligible)
- Instance type:
			Select t3.medium
- Key pair:
		 Create a new key or use an existing key
- Network settings:
		VPC: Select the Default VPC
		Subnet: No preference
		Auto-assign public IP: Enable
- Create a new security group:
		Name: Jenkins_SG
		Description: Security group for Jenkins Server
		Add the following rules: 
		Type: SSH, (port 22), Source: 0.0.0.0/0 (SSH)
		Type: HTTP, (port 80), Source: 0.0.0.0/0  (HTTP)
		Type: HTTP, (port 443), Source: 0.0.0.0/0  (HTTPS) (More secure)
		Type: Custom TCP, (port 8080), Source: 0.0.0.0/0 (Jenkins)
		
- Configure storage:
		Keep the default settings
- Advanced details:
		Leave as default unless you have specific requirements
- Review and launch the instance

After the instance is launched, you'll have a t3.medium EC2 instance named "Jenkins" in the public subnet of your Default VPC, with a security group allowing inbound traffic on ports 22 (SSH) and 80 (HTTP) and 8080(Jenkins).
Install Jenkins on the Server using the installation script: ![Install Jenkins Steps Here](scripts)

### Important:
Creating SSH keys on the Jenkins server and distributing them to  your servers ensures a secure connection between the servers. 
 Testing the connection by SSH'ing into your other servers from Jenkins' server 
 verifies that the servers can connect without manual intervention and adds the 
 servers to the "list of known hosts”. A "known host" is a remote server that your system recognizes and trusts for SSH connections based on its stored public key. 
 This is important because it helps to ensure secure and verified SSH connections.
