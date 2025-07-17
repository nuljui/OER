const express = require('express');
const fetch = require('node-fetch');
const cors = require('cors');
const path = require('path');

const app = express();
const port = process.env.PORT || 3000;

// Enable CORS for all routes
app.use(cors());

// Serve static files (your HTML, CSS, etc.)
app.use(express.static('.'));

// Xbox API proxy endpoints
app.get('/api/xbox/*', async (req, res) => {
  try {
    // Extract the path after /api/xbox
    const xboxPath = req.url.replace('/api/xbox', '');
    const xboxUrl = `https://xbl.io/api/v2${xboxPath}`;
    
    console.log(`Proxying Xbox API call: ${xboxUrl}`);
    
    const response = await fetch(xboxUrl, {
      method: 'GET',
      headers: {
        'X-Authorization': 'd2c2a0c5-ce9b-4e59-91aa-d0a73c45ac87',
        'Accept': 'application/json'
      }
    });
    
    if (!response.ok) {
      throw new Error(`Xbox API error: ${response.status}`);
    }
    
    const data = await response.json();
    res.json(data);
  } catch (error) {
    console.error('Xbox API proxy error:', error);
    res.status(500).json({ error: error.message });
  }
});

// Serve your main HTML file
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'index.html'));
});

app.listen(port, () => {
  console.log(`🚀 OGA Platform running on port ${port}`);
  console.log(`📡 Xbox API proxy available at /api/xbox/*`);
}); 