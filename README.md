# Fonctionnement

L'application suit un order linéaire pour créer deux ordres et ensuite affiche le prix du marché et la profondeur.
Un choix est proposé pour supprimer un ordre (non fonctionnel)

Dans la classe Market j'ai créer un objet orders qui recense tous les ordres passés ainsi que les deux tableaux bids et asks qui contiennent les ordres de vente et d'achat.

orders me permet de retrouver par une id l'ordre passé et de le supprimer dans le tableau orders avec delete_at mais pas encore dans le tableau bids ou asks.
