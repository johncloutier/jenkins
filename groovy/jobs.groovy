import jenkins.model.*
import groovy.io.FileType

//def jobName = "MyProject"
//String configXml = new File('/usr/local/jenkins/jobs/myproject.xml').text
//def xmlStream = new ByteArrayInputStream(configXml.getBytes())
//Jenkins.instance.createProjectFromXML(jobName, xmlStream)

def jobs = []

def dir = new File("/usr/local/jenkins/jobs")
dir.eachFileRecurse (FileType.FILES) { file ->
  jobs << file
}
for (job in jobs) {
  String configXml = job.text
  def xmlStream = new ByteArrayInputStream(configXml.getBytes())
  String jobName = job.getName()
  Jenkins.instance.createProjectFromXML(jobName.substring(0, jobName.indexOf('.')), xmlStream)
}

