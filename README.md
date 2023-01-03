# IngegneriaDelSoftware_2022-2023
<a >
    <img src="documenti/img/logo.png" alt="logo" title="AutomationWare" align="right" height="80" />
</a>

**Gruppo:** G.A.M.E.S. <br/>
**Project leader:** Sebastiano Sartori 886809@stud.unive.it  <br/>
**Altri membri:**  <br/>
* Giovanni Berto 886060@stud.unive.it
* Edoardo Cecchinato 880759@stud.unive.it
* Andrea Da Lio 884046@stud.unive.it
* Mattia Dei Rossi 885768@stud.unive.it

----------------------------

## Frontend: 
### Aspetti implementati:
* Struttura di base dell'applicazione, con navigazione tra le pagine;
#### Pagina segnalazioni:
* visualizzazione della lista dell'utente e della lista del quartiere
* creazione e cancellazione di segnalazioni;
#### Pagina bisogni:
* visualizzazione della lista dell'utente, della lista del quartiere e della lista di richieste prese in carico dall'utente
* creazione, cancellazione, aggiornamento e visualizzazione delle singole richieste
* possibilità di Soddisfare le richieste
#### Pagina servizi:
* visualizzazione della lista dell'utente e della lista del quartiere
*reazione, cancellazione, aggiornamento e visualizzazione dei singoli servizi;
#### Pagina profilo:
* visualizzazione informazioni del profilo
* modifica del profilo
* logout;
#### Dashboard:
* pagina iniziale 
* reindirizzamento alle altre pagine. 
### TO DO:
* Sistema di notifica delle segnalazioni
* Miglioramenti grafici
* Completare gestione errori 
* Inserire aggiornamento manuale delle liste

----------------------------
## Backend:
### Schema
- [Schema relazionale](./documenti/schema/Schema_relazionale.pdf)
- [Schema ad oggetti](./documenti/schema/Schema_a_oggetti.pdf)

### Api:
* *signup:* 
  * signup the new user with the data specified in the post request
* *login:* 
  * login the user with the data specified in the post request, return the session token of the user
* *logout:* 
  * logout the user with the email specified in the post request
* *delete-account:* 
  * delete the user specified
* *token:* 
  * compare the token passed and the token in the db for the user specified
* *neighborhoods:* 
  * return a list of dictionary that represent all the neighborhoods present in the app
* *profile:*
  * get the injsonation of the user with the token specified 
  * update the specified fields in the profile of the user with the token specified
* *list/elem:*
  * get a list of elem (services, needs, reports) for the user with the token specified
* *mylist/elem:*
  * get the personal list of elem (services, needs, reports) for user specified
  * update the specified fields in the personal list of type elem (services, needs, reports) for user specified
* *assist-list:*
  * get the list of needs the user specified have to assist
* *new/elem:*
  * create a new element of type elem (services, needs, reports), return the id of the new element
* *delete/elem:*
  * delete element of type elem (services, needs, reports) with the id passed
* *assist:*
  * the user specified can solve the need with id passed
### Test:
* *Api:*
  * test_signup
  * test_login
  * test_neighborhoods
  * test_reports
  * test_needs
  * test_services
  * test_profile
  * test_logout
  * test_delete_account
* *Unit:*
  * test_models

risultati dei test [report](./server/report.log)
### Database:
* schema a oggetti
* schema relazionale
* populate
* token management
### Azure Cloud:
* impostazione Azure
* app services
* postgreSQL servers flexible
### TO DO:
* completamento test
* miglioramento sicurezza
* stress test

