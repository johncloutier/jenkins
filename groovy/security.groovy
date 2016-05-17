import jenkins.model.*
import hudson.security.*
 
def instance = Jenkins.getInstance()
//def hudsonRealm = new HudsonPrivateSecurityRealm(false)
//instance.setSecurityRealm(hudsonRealm)
instance.setSlaveAgentPort(50001)
instance.save()
