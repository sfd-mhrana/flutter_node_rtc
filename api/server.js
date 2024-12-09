const express = require('express');
const http = require('http');
const { Server } = require('socket.io');

const app = express();
const server = http.createServer(app);
const io = new Server(server);

// Serve static files (optional, for testing)
app.get('/', (req, res) => {
    res.send('Video Call Server Running');
});

io.on('connection', (socket) => {
    console.log('User connected:', socket.id);

    socket.on('join-room', (roomId) => {
        socket.join(roomId);
        socket.to(roomId).emit('user-connected', socket.id);
    });

    socket.on('signal', (data) => {
        io.to(data.to).emit('signal', { from: socket.id, signal: data.signal });
    });

    socket.on('disconnect', () => {
        console.log('User disconnected:', socket.id);
    });
});

const PORT = 3000; // Replace with your desired port
const HOST = '192.168.26.102'; // Replace with your desired IP address

server.listen(PORT,HOST, () => {
    console.log(`Server running on port ${PORT}`);
});
