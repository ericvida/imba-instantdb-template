This project combines InstantDB (a very easy database),
with Imba (A very easy and fun web programming language)
![App Screenshot](./screenshot-01.jpg)
To setup, Make an account at [instantdb.com](https://instantdb.com) then follow the steps below.
1. Create `+ new app`
2. Click on you newly created app
3. Copy/Paste APP's ID value line 1 of main.imba `const INSTANT_APP_ID = "YOUR APPID HERE" (Do not leave APP ID here in production or on public repository. You must place the APP ID in an Enviroment Variable for hosting.)
4. Click on `Explorer`
5. Click on `create a namespace` or `+ create` and create a namespace called notes 
6. Click on the newly created `notes` namespace.
7. Click on `Edit Schema` button.
8. Click on `+ New attributes` and name it `content`. You may leave constraints unchecked 9. Click on `Create attribute`
10. Clone this repository `git clone https://github.com/ericvida/imba-instantdb-template.git`
11. run `npm install` and then `npm run dev` and your Notes CRUD app should be running on localhost:3000 fully powered by Imba and InstantDB.
![](./screenshot-02.jpg)