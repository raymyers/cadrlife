import com.bleedingwolf.ratpack.Ratpack
import com.bleedingwolf.ratpack.RatpackServlet
import com.cadrlife.jhaml.JHaml
import org.apache.commons.lang.StringEscapeUtils
import groovy.text.GStringTemplateEngine

def haml(String filename) {
	haml(filename, [:])
}

def haml(String filename, extraBindings) {
        def bindings = [:]
        bindings.layout = [:]
        bindings.layout.pageTitle = "Home"
        bindings.layout.menuItems = [
		["Home","/"],
		['Projects', 'projects'],
		['Programming', 'programming'],
		['DJ Pompey', 'dj_pompey'],
		//['Martial Art', 'martial_art'],
		['Quotes', 'quotes'],
		['Contact', 'contact'],
		['Links', 'links']]

	bindings.putAll(extraBindings)
        bindings.layout.pageContent = hamlNoLayout(filename, bindings)
	bindings.html = [escape:{o ->
		StringEscapeUtils.escapeHtml(o.toString())
	}]
	bindings.link = [to:{path ->
		config.rootDir + path
	}]
	bindings.include = [
		css: {css -> "<link rel='stylesheet' href='style/${css}'/>"},
		js: {js -> "<script type='text/javascript' src='js/${js}'/>"}
	]
	hamlNoLayout "views/layouts/app.haml", bindings
}

def hamlNoLayout(String filename, extraBindings) {
	def bindings = [:]
	bindings.putAll(extraBindings)
	def gsp = new JHaml().parse(new File(filename).text)
        def engine = new GStringTemplateEngine()
        def template = engine.createTemplate(new StringReader(gsp)).make(bindings)
        template.toString()
}

def urlmap = [
    "/": "views/index.haml",
    "/projects": "views/projects.haml",
    "/programming": "views/programming.haml",
    "/martial_art": "views/martial_art.haml",
    "/dj_pompey": "views/dj_pompey.haml",
    "/quotes": "views/quotes.haml",
    "/contact": "views/contact.haml",
    "/links": "views/links.haml"
]

def app = Ratpack.app {
    set "public", "public"
    urlmap.each {path, view ->
        get(path) {
            setHeader 'Content-Type', 'text/html'
            haml view, [:]
        }
	haml("views/contact.haml", [:])
    }
}

RatpackServlet.serve(app,8080)

