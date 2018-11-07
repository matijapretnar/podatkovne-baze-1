Če so gesla spravljena takole:

uporabnisko_ime  |  geslo
-----------------|-----------------
pikec230         | jaz.sem.pikec.1
heker            | rceour2g3r12hnto
stefka1924       | geslo
marjana1924      | geslo

jih hekerji hitro odkrijejo z uporabo `SELECT * FROM uporabniki`.

Če jih poprej zakodiramo, samih gesel ne vedo, vidijo pa, da imata `stefka1924`
in `marjana1924` isto geslo.

uporabnisko_ime  |  geslo
-----------------|----------------------------------
pikec230         | 3d65fb88d43df1aa73c772f0fbe4aba7
heker            | 860ea9e53ad9e4523869ce3028766a0c
stefka1924       | ae404a1ecbcdc8e96ae4457790025f50
marjana1924      | ae404a1ecbcdc8e96ae4457790025f50

Če pa za kodiranje uporabimo še sol, pa imata `stefka1924` in `marjana1924`
popolnoma drugačno zakodirano geslo.

uporabnisko_ime  |  sol_in_geslo
-----------------|-----------------------------------------
pikec230         | 312123$2c12a661372f5f031b42c376c399aea3
heker            | auoetd$eae626eb35bd2b30fbf04f8039c4d960
stefka1924       | blaueo$e973514e5e425b8da03c5ebacaef033d
marjana1924      | an23g4$64271be6c0db902fcec1e334682f3d42


