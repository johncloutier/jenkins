import jenkins.model.*

// Set admin email address
def jenkinsLocationConfiguration = JenkinsLocationConfiguration.get()
jenkinsLocationConfiguration.setAdminAddress("Jenkins Admin <jenkins@domain.com>")
jenkinsLocationConfiguration.save()

// Set email server configuration
def inst = Jenkins.getInstance()
def desc = inst.getDescriptor("hudson.tasks.Mailer")
desc.setSmtpAuth("username", "password")
desc.setReplyToAddress("jenkins@domain.com")
desc.setSmtpHost("hostname")
desc.setUseSsl(true)
//desc.setSmtpPort("[SMTP port]")
desc.setCharset("UTF-8")

desc.save()
