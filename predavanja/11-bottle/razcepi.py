from bottle import route, run, template

@route('/')
def index():
    1 / 0
    return 'Pozdravljeni na strani za iskanje <b>pravih</b> deliteljev!'

@route('/pomoc/')
def pomoc():
    return 'Pojdi na stran /delitelji/xxx/ za delitelje števila xxx.'

@route('/delitelji/<n>/')
def delitelji(n):
    n = int(n)
    return ', '.join(
        str(d) for d in range(2, n) if n % d == 0
    )

run(reloader=True, debug=True)
