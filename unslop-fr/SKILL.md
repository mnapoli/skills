---
name: unslop-fr
description: Détecter et supprimer les tics d'écriture IA dans un texte en français, puis le réécrire avec une voix humaine. À utiliser quand on demande de dé-slopifier, humaniser, alléger ou nettoyer de la prose française (docs, rapports, artifacts, réponses de conversation). Pour un texte en anglais, utiliser unslop.
---

# Unslop (français)

Identifier et éliminer les tics d'écriture des LLM dans un texte français, en préservant le sens et en y remettant une voix. Adaptation française de la skill [unslop de Cursor](https://github.com/cursor/plugins/blob/main/pstack/skills/unslop/SKILL.md) : la majorité des patterns sont structurels et se transposent tels quels, le vocabulaire et la typographie demandent une adaptation.

## Processus

1. Scanner le texte pour les patterns ci-dessous.
2. Réécrire en préservant le sens, les faits et le ton. Ne jamais modifier les données, chiffres, noms ou affirmations.
3. Remettre de la voix : des opinions quand l'auteur en a, du concret, un rythme varié.
4. Relire le résultat, titres compris — les titres ne sont pas exemptés.

## Le style visé

- **Des phrases courtes sont bien, voire préférables** — tant que ce sont de vraies phrases françaises qu'un humain prononcerait. Pas de style télégraphique (« = », « vs », « ×1,5 », « → ») dans la prose.
- **Le gras est bienvenu pour structurer** : phrase-clé en tête d'un item de liste, labels, chiffres importants. Pas de gras d'emphase dispersé au milieu des phrases.
- Des opinions plutôt que des listes neutres. Du concret plutôt que des généralités.
- Une imperfection structurelle est normale ; le parallélisme parfait sent la machine.

## Patterns à détecter et corriger

### Contenu

1. **Emphase creuse** — « un moment charnière », « un paysage en constante évolution », « une empreinte indélébile » → couper, énoncer les faits.
2. **Références sans contexte** → choisir une source et l'expliquer.
3. **Participes creux** — « soulignant », « garantissant », « illustrant » → supprimer ou donner le mécanisme réel.
4. **Adjectifs promotionnels** — « véritable », « incontournable », « niché au cœur de », « vibrant », « époustouflant » → langage neutre.
5. **Attributions vagues** — « les experts estiment », « les études montrent » → nommer la source ou retirer l'affirmation.
6. **Obstacles génériques** — « malgré les défis... prospère » → remplacer par le détail réel.

### Langue

7. **Vocabulaire IA en français** — « plonger dans », « explorer », « crucial », « clé » à toutes les sauces, « riche et varié », « au cœur de », « à l'ère de », « s'inscrire dans une démarche », « dans le cadre de », « il convient de noter que », « il est important de souligner que », « force est de constater », « nul doute que » → équivalents simples ou suppression.
8. **Copules gonflées** — « constitue », « se veut », « s'impose comme », « se positionne comme », « représente » → « est » ou « a ».
9. **« Ce n'est pas X, c'est Y » / « pas seulement X, mais Y »** → dire directement le point.
10. **Triade forcée** (rythme ternaire systématique) → utiliser la taille naturelle du groupe, même si c'est deux ou quatre.
11. **Valse des synonymes** — appeler la même chose par trois noms → choisir un terme et le répéter.
12. **Fausses plages** — « de X à Y » sur des échelles incomparables → lister directement.

### Style

13. **Tirets cadratins en cascade** — le français utilise le tiret, mais pas trois par phrase → points, virgules, points-virgules.
14. **Deux-points en connecteur systématique** → réécrire en phrases autonomes.
15. **Gras d'emphase dispersé** dans les phrases → retirer. Le gras structurant reste (tête d'item, label, chiffre-clé).
16. **Listes qui répètent leur titre** — « **Performance :** la performance s'améliore... » → prose, ou corriger l'attaque.
17. **Emojis décoratifs** dans les titres et puces → retirer (un emoji porteur de sens, type légende, peut rester).
18. **MAJUSCULES d'emphase** — « c'est LA solution », « il n'y a AUCUNE offre » → reformuler l'emphase par les mots.
19. **Anglicismes inutiles** — « table » pour tableau, « supporter » pour prendre en charge, « digital » pour numérique, « adresser un problème » pour traiter → le mot français. Les termes techniques établis restent (hotswap, firmware, layout...).

### Artefacts de conversation

20. **Phrases de chatbot** — « J'espère que cela vous aidera ! » → supprimer.
21. **Avertissements de couverture** — « Bien que les détails soient limités... » → sourcer ou retirer.
22. **Flagornerie** — « Excellente question ! » → répondre directement.

### Remplissage

23. **Tournures verbeuses** — « afin de » → « pour » ; « dans le but de » → « pour » ; « du fait que » → « parce que » ; « au sein de » → « dans » ; « la mise en place de » → verbe direct.
24. **Sur-précaution** — « pourrait potentiellement éventuellement » → « peut ».
25. **Conclusions génériques** — « l'avenir s'annonce prometteur » → énoncer des faits, ou ne pas conclure.

### Jargon

26. **Métaphores abstraites plaquées** — « levier », « flywheel », « boulevard », « douve », « ADN » (au figuré), « écosystème » (hors sens propre) → termes concrets.

### Parler simplement

27. **Ressenti au lieu du mécanisme** — « reste à portée de main » → expliquer la fonction réelle ou couper.
28. **Phrases denses** → une idée par phrase.
29. **Voix passive** — « les requêtes sont validées » → « le compilateur valide les requêtes ».
30. **Verbes faibles + adverbes** — « fonctionne rapidement » → « est rapide », ou citer des chiffres ; « utiliser » convient, « exploiter »/« tirer parti de » rarement.

## À conserver (différences avec la version anglaise)

- **La typographie française** : guillemets « à chevrons », espaces insécables avant ; : ! ?, accents sur les capitales (É, À). La règle anglaise « guillemets droits » ne s'applique pas.
- **La règle « Title Case » ne s'applique pas** : le français capitalise seulement le premier mot des titres.
- **Les tableaux de données et listes énumératives** : c'est de la présentation de données, pas du slop.
- **Les termes propres à l'auteur** et le vocabulaire technique du domaine.
- **Les titres doivent aussi être naturels** : des phrases ou des noms qu'un humain dirait, pas des formules ni des slogans.
