This project combines InstantDB (a very easy database),
with Imba (A very easy and fun web programming language)
![App Screenshot](/App%20screenshot@2x.jpg)
1. Go to instantdb.com abd make an account,
2. create namespace
3. Pass APP ID of namespace into INSTANT_APP_ID below.
4. Under explorer on instantdb.com website, create a collection called notes, 
5. Add property to the note schema called 'content'.
6. run `npm run dev` and app should run on localhost:3000 and you should be able to add do CRUD operations on InstantDB notes.


When hosting your app, place INSTANT_APP_ID in an environment vairable for safety.