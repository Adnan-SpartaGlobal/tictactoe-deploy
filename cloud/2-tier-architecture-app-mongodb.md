# Connecting the app to the database (two-tier)

## Steps

**1. Setup**

- From the DB instance's summary page in the AWS console. You need it for step 3.
- ssh into both instances
![alt text](duo-VMs.png)


**2. Stop the app**

```bash
pm2 kill
```

- Refreshing the site now should give a 502 Bad Gateway. That's fine, it means nginx is up with nothing behind it.
- **Note:** Use `sudo pm2 kill` to kill everything if the above doesn't work, it's okay for a fresh startup instance or image

**3. Set the variable on app instance**

```bash
export MONGODB_URI="mongodb://<DB_PUBLIC_IP>:27017/tic-tac-toe"
```

- Swap in the real IP

**4. Check it saved**

```bash
printenv MONGODB_URI
```

- `export` doesn't print anything, so this is the only way to know it worked. It should print the address back.

**5. Go to the app folder and install**

```bash
cd ~/tictactoe-deploy/app
npm install
```

- The database is empty, so `npm install` also connects to it 
- It puts in 10 dummy scoreboard records (aka seeding). 

**6. Start the app**

```bash
pm2 start index.js --name tictactoe
```

**7. Check the browser**

Refresh the app's IP. It should now show the MongoDB mode instead of "client local stateful", and a global scoreboard further down. That's the two-tier setup working.
![alt text](ttt-MongoDB.png)