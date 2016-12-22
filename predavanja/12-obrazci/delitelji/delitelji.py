from bottle import route, run, template, request
import modeli

@route('/')
def index():
    return template('zacetna_stran')

@route('/pomoc/')
def pomoc():
    return 'Pojdi na stran /delitelji/xxx/ za delitelje števila xxx.'

@route('/delitelji/<n>/')
def delitelji(n):
    n = int(n)
    return template('seznam_deliteljev', n=n, delitelji=modeli.delitelji(n))

@route('/delitelji_prek_obrazca/')
def delitelji_prek_obrazca():
    n = int(request.query.stevilo)
    return template('seznam_deliteljev', n=n, delitelji=modeli.delitelji(n))

run(reloader=True, debug=True)
