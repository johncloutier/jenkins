import hudson.model.ListView
import hudson.model.Hudson
import java.util.regex.Matcher
import java.util.regex.Pattern

def list_name = 'Templates'
def list_pattern = '.*Template'

def pattern = Pattern.compile(list_pattern)
v = new ListView(list_name);
v.setIncludeRegex(list_pattern)

Hudson.instance.addView(v);

