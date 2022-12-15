# Fonctionnement

La méthode initialize est la méthode de construction de la classe. Elle initialise les attributs @base, @quote, @bids, @asks et @matches qui sont utilisés pour stocker les informations sur les ordres soumis au marché.

La méthode submit permet de soumettre un ordre au marché. L'ordre est ajouté à la liste @bids ou @asks, en fonction de la valeur de l'attribut side.

La méthode market_price calcule et affiche le prix du marché en prenant la moyenne des prix des ordres @bids et @asks les plus élevés ou les plus bas, selon le cas. Le résultat est arrondi à deux chiffres après la virgule et affiché avec un nombre fixe de chiffres après la virgule.

La méthode market_depth affiche la profondeur du marché en parcourant les listes @bids et @asks et en affichant les prix et les montants des ordres les plus élevés ou les plus bas, selon le cas. Le résultat est affiché dans un format JSON.

La méthode cancel_order permet d'annuler un ordre en recherchant l'ID de l'ordre dans les listes @bids et @asks et en supprimant l'ordre correspondant.

La méthode match compare les premiers ordres @bids et @asks pour voir s'ils correspondent et si c'est le cas, exécute un match en enlevant les ordres correspondants des listes @bids et @asks et en ajoutant un nouvel ordre dans la liste @matches.
