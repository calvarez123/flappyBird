const WebSocket = require('ws');
const { v4: uuidv4 } = require('uuid');

class Obj {
    constructor() {
        this.ws = null;
        this.socketsClients = new Map();
        this.clientesEchados = [];
    }

    init(httpServer, port) {
        // Define empty callbacks
        this.onConnection = (socket, id) => { };
        this.onMessage = (socket, id, obj) => { };
        this.onClose = (socket, id) => { };

        // Run WebSocket server
        this.ws = new WebSocket.Server({ server: httpServer });
        console.log(`Listening for WebSocket queries on ${port}`);

        // What to do when a websocket client connects
        this.ws.on('connection', (ws) => { this.newConnection(ws); });
    }

    end() {
        if (this.ws) {
            this.ws.close();
        }
    }

    newConnection(con) {
        console.log("Client connected");

        // Add client to the clients list
        const id = "C" + uuidv4().substring(0, 5).toUpperCase();
        const metadata = { id };
        this.socketsClients.set(con, metadata);

        // Send clients list to everyone
        if (this.onConnection && typeof this.onConnection === "function") {
            this.onConnection(con, id);
        }

        // What to do when a client is disconnected
        con.on("close", () => {
            this.closeConnection(con);
            this.socketsClients.delete(con);
        });

        // What to do when a client message is received
        con.on('message', (bufferedMessage) => { this.newMessage(con, id, bufferedMessage); });
    }

    closeConnection(con) {
        if (this.onClose && typeof this.onClose === "function") {
            const id = this.socketsClients.get(con)?.id;
            if (id) {
                this.onClose(con, id);
            }
        }
    }

    // Send a message to all websocket clients except those who have been "ejected"
    broadcast(msg) {
        this.ws.clients.forEach((client) => {
            const metadata = this.socketsClients.get(client);
            if (metadata && !this.clientesEchados.includes(metadata.id) && client.readyState === WebSocket.OPEN) {
                client.send(msg);
            }
        });
    }
    broadcastExcept(msg, idToExclude) {
        this.ws.clients.forEach((client) => {
            if (client.readyState === WebSocket.OPEN && this.socketsClients.get(client).id !== idToExclude) {
                client.send(msg);
            }
        });
    }
    // A message is received from a websocket client
    newMessage(ws, id, bufferedMessage) {
        const messageAsString = bufferedMessage.toString();
        if (this.onMessage && typeof this.onMessage === "function") {
            this.onMessage(ws, id, messageAsString);
        }
    }

    getClientData(id) {
        for (let [client, metadata] of this.socketsClients.entries()) {
            if (metadata.id === id) {
                return metadata;
            }
        }
        return null;
    }

    getClientsIds() {
        const clients = [];
        this.socketsClients.forEach((value, key) => {
            clients.push(value.id);
        });
        return clients;
    }

    getClientsData() {
        const clients = [];
        for (let [client, metadata] of this.socketsClients.entries()) {
            clients.push(metadata);
        }
        return clients;
    }
}

module.exports = Obj;
