# Full-stack Development Made Easy with Imba + InstantDB

Get your app up and running in 1 minute with Imba and InstantDB.

![App Screenshot](./screenshot-01.jpg)

## Setup Imba Project
1. **Clone the Repository**:
    - Run `git clone https://github.com/ericvida/imba-instantdb-template.git app-folder-name`.
2. **Open directory**
   `cd ./app-folder-name`
3. **Install Dependencies**:
    - run `npm install`.
4.  **Run the App**:
    - Execute `npm run dev`.
    - Your Notes CRUD app should now be running on `localhost:3000`, fully powered by Imba and InstantDB.

## Setup InstantDB
**Prerequisite**: Sign up and login to [instantdb.com](https://instantdb.com).

1. **Create a New App**.
   - Click on `+ new app`
2. **Copy Your APP ID**:
    - Click on your newly created app.
    - Copy the APP's ID and paste it as a string value in `const INSTANT_APP_ID = "YOUR APP ID HERE"` on line 1 of `/src/main.imba`.
    - **Note**: For security, do not expose your APP ID in a public repository or web hosting service before setting up proper [user permissions](https://www.instantdb.com/docs/permissions) on your app.
3. **Click on `Explorer` Tab**
4. **Create a `notes` Namespace**:
    - Click on `create a namespace` or `+ create`.
    - Name the new namespace `notes` in lowercase.
5. **Click on notes**
6. Click on the `Edit Schema` button.
    - Within your newly created `notes` namespace.
7. **Click on `+ New attribute`**
8. **Name it `content`**
   - Leave constraints unchecked.
9.  **Click on `Create Attribute`**
![App Screenshot](./screenshot-02.jpg)
![App Screenshot](./screenshot-gif.gif)