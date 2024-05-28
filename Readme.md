Full-stack doesn't get easier than Imba + InstantDB.
You'll be up and running in 10 easy steps.
![App Screenshot](./screenshot-01.jpg)
To setup, Make an account at [instantdb.com](https://instantdb.com) then follow the steps below.
1. Create `+ new app`
2. Click on you newly created app
3. Copy/Paste APP's ID in as a `string` value in `const INSTANT_APP_ID = "YOUR APPID HERE"` on line 1 of `/src/main.imba`.
4. Click on `Explorer`
5. Click on `create a namespace` or `+ create` and create a namespace called notes 
6. Click on the newly created `notes` namespace.
7. Click on `Edit Schema` button.
8. Click on `+ New attributes` and name it `content`. You may leave constraints unchecked 9. Click on `Create attribute`
9.  Clone this repository `git clone https://github.com/ericvida/imba-instantdb-template.git`
10. run `npm install` and then `npm run dev` and your Notes CRUD app should be running on localhost:3000 fully powered by Imba and InstantDB.
![](./screenshot-02.jpg)