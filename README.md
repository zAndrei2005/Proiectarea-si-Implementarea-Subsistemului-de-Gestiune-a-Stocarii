# Simulator de Gestiune a Stocării (Assembly)

Acest proiect implementează un simulator de spațiu de stocare în limbaj de asamblare, conceput pentru a emula operațiunile de bază ale unui sistem de fișiere atât în modelul de memorie unidimensional, cât și în cel bidimensional.

Simulatorul oferă funcționalități fundamentale similare cu cele ale unui manager de memorie al unui sistem de operare minimal:

* **Add (Adăugare)** — alocă un fișier nou în memorie.
* **Get (Preluare)** — identifică un fișier stocat folosind descriptorul său unic (ID între 1 și 255).
* **Delete (Ștergere)** — elimină un fișier și eliberează blocurile ocupate (setând descriptorul la 0).
* **Defragment (Defragmentare)** — reorganizează memoria pentru a elimina fragmentarea și a optimiza utilizarea spațiului.

---

## Implementare

Proiectul cuprinde două versiuni principale:

### 1. Memorie Unidimensională (Task 1)

* Memoria este privită ca o secvență liniară de blocuri.
* Capacitatea totală este de **8MB**, împărțită în blocuri de **8kB**.
* Fișierele sunt stocate contiguu; dacă nu există spațiu continuu, scrierea nu este posibilă.

### 2. Memorie Bidimensională (Task 2)

* Memoria este reprezentată sub formă de matrice de blocuri.
* Procesul de alocare și regăsire este mai complex, utilizând coordonate de tip `(startX, startY)` și `(endX, endY)`.
* Defragmentarea compactează fișierele în matrice, mutând spațiile libere spre "dreapta-jos".

---

## Testare și Verificare

Proiectul include un folder de teste (`tests/`) și un script de testare bazat pe Python (`checker.py`). Acesta:

* Verifică automat corectitudinea implementării în asamblare.
* Rulează o colecție de cazuri de test predefinite (fișiere `.in` / `.out`).
* Calculează un scor final pe baza funcționalităților îndeplinite cu succes.

---

### Cum se rulează

Pentru a rula testele pe un sistem Ubuntu:

```bash
python3 checker.py

```
