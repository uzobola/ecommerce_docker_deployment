### The next few steps will guide you on how to set up a Jenkins Node Agent.
a. Make sure both instances are running and then log into the Jenkins console in the Jenkins Manager instance. On the left side of the home page under the navigation panel and "Build Queue", Click on "Build Executor Status"
b. Click on "New Node"
c. Name the node "build-node" and select "Permanent Agent"
d. On the next screen,
  i. "Name" should read "build-node"
  ii. "Remote root directory" == "/home/ubuntu/agent"
  iii. "Labels" == "build-node"
  iv. "Usage" == "Only build jobs with label expressions matching this node"
  v. "Launch method" == "Launch agents via SSH"
  vi. "Host" is the public IP address of the Node Server
  vii. Click on "+ ADD" under "Credentials" and select "Jenkins".
  viii. Under "Kind", select "SSH Username with private key"
  ix. "ID" == "build-node"
  x. "Username" == "ubuntu"
  xi. "Private Key" == "Enter directly" (paste the entire private key of the Jenkins node instance here. This must be the .pem file)
  xi. Click "Add" and then select the credentials you just created.  
  xii. "Host Key Verification Strategy" == "Non verifying Verification Strategy"
  xiii. Click on "Save"

e. Back on the Dashboard, you should see "build-node" under "Build Executor Status". Click on it and then view the logs. If this was successful it will say that the node is "connected and online".
  
