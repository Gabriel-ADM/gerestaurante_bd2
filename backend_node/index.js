const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();
const port = 8000;
app.use(cors());
app.use(express.json());

// Create a MySQL connection
const connection = mysql.createConnection({
    host: 'localhost',
    user: 'Gabriel',
    password: '&ESZz5y*6W2q',
    database: 'gerestaurante'
});

connection.connect((err) => {
    if (err) {
        console.error('Error connecting to MySQL:', err.stack);
        return;
    }
    console.log('Connected to MySQL as id ' + connection.threadId);
});

app.get('/', (req, res) => {
    res.send('Hello, World!');
});

app.get('/clientes', (req, res) => {
    let query = 'SELECT * FROM cliente';
    const { reduced } = req.query;
    if (reduced) {
        query = 'SELECT id, nome FROM cliente';
    }

    connection.query(query, (err, results) => {
        if (err) {
            console.error('Error running query:', err.stack);
            res.status(500).send('Error running query');
            return;
        }
        res.json(results);
    });
});
app.post('/cliente', (req, res) => {
    const { email, nome } = req.body;

    if (!email || !nome) {
        return res.status(400).send('Missing required fields: email, nome');
    }

    const query = `INSERT INTO cliente(email, nome) VALUES ('${email}','${nome}')`
    connection.query(query, (err, results) => {
        if (err) {
            console.error('Error running query:', err.stack);
            res.status(500).send('Error running query');
            return;
        }
        res.json(results);
    });
})
app.delete('/cliente/:id', (req, res) => {
    const { id } = req.params;

    if (!id) {
        return res.status(400).send('ID is required');
    }

    const query = `DELETE FROM cliente WHERE id = ${id}`
    connection.query(query, (err, results) => {
        if (err) {
            console.error('Error running query:', err.stack);
            return res.status(500).send('Error running query');
        }

        if (results.affectedRows === 0) {
            return res.status(404).send('Cliente not found');
        }

        res.status(200).json({ message: 'Cliente deleted successfully' });
    });
})
app.put('/cliente/:id', (req, res) => {
    const { id } = req.params;
    const { nome, email } = req.body;

    if (!id || !nome || !email) {
        return res.status(400).send('ID, nome, and email are required');
    }

    // Use parameterized queries to prevent SQL injection
    const query = 'UPDATE cliente SET nome = ?, email = ? WHERE id = ?';
    connection.query(query, [nome, email, id], (err, results) => {
        if (err) {
            console.error('Error running query:', err.stack);
            return res.status(500).send('Error running query');
        }

        if (results.affectedRows === 0) {
            return res.status(404).send('Cliente not found');
        }

        res.status(200).json({ message: 'Cliente updated successfully' });
    });
});
app.get('/funcionarios', (req, res) => {
    let query = 'SELECT * FROM funcionario';
    const { reduced } = req.query;
    if (reduced) {
        query = 'SELECT id, nome FROM funcionario';
    }

    connection.query(query, (err, results) => {
        if (err) {
            console.error('Error running query:', err.stack);
            res.status(500).send('Error running query');
            return;
        }
        res.json(results);
    });
});
app.post('/funcionario', (req, res) => {
    const { email, nome, remuneracao } = req.body;

    if (!email || !nome) {
        return res.status(400).send('Missing required fields: email, nome');
    }

    const query = `INSERT INTO funcionario(email, nome, remuneracao) VALUES ('${email}','${nome}','${remuneracao}')`
    connection.query(query, (err, results) => {
        if (err) {
            console.error('Error running query:', err.stack);
            res.status(500).send('Error running query');
            return;
        }
        res.json(results);
    });
})
app.delete('/funcionario/:id', (req, res) => {
    const { id } = req.params;

    if (!id) {
        return res.status(400).send('ID is required');
    }

    const query = `DELETE FROM funcionario WHERE id = ${id}`
    connection.query(query, (err, results) => {
        if (err) {
            console.error('Error running query:', err.stack);
            return res.status(500).send('Error running query');
        }

        if (results.affectedRows === 0) {
            return res.status(404).send('funcionario not found');
        }

        res.status(200).json({ message: 'funcionario deleted successfully' });
    });
})
app.put('/funcionario/:id', (req, res) => {
    const { id } = req.params;
    const { nome, email, remuneracao } = req.body;

    if (!id || !nome || !email) {
        return res.status(400).send('ID, nome, and email are required');
    }

    // Use parameterized queries to prevent SQL injection
    const query = 'UPDATE funcionario SET nome = ?, email = ?, remuneracao = ? WHERE id = ?';
    connection.query(query, [nome, email, remuneracao, id], (err, results) => {
        if (err) {
            console.error('Error running query:', err.stack);
            return res.status(500).send('Error running query');
        }

        if (results.affectedRows === 0) {
            return res.status(404).send('Funcionario not found');
        }

        res.status(200).json({ message: 'Funcionario updated successfully' });
    });
});
app.get('/pedidos', (req, res) => {
    const query = 'SELECT * FROM pedido_completo';

    connection.query(query, (err, results) => {
        if (err) {
            console.error('Error running query:', err.stack);
            res.status(500).send('Error running query');
            return;
        }
        res.json(results);
    });
});
app.get('/produtos', (req, res) => {
    let query = 'SELECT * FROM produto';
    const { reduced } = req.query;
    if (reduced) {
        query = 'SELECT id, nome FROM produto';
    }
    connection.query(query, (err, results) => {
        if (err) {
            console.error('Error running query:', err.stack);
            res.status(500).send('Error running query');
            return;
        }
        res.json(results);
    });
});
app.get('/estoque', (req, res) => {
    const query = 'SELECT * FROM estoque';

    connection.query(query, (err, results) => {
        if (err) {
            console.error('Error running query:', err.stack);
            res.status(500).send('Error running query');
            return;
        }
        res.json(results);
    });
});
app.post('/pedido', (req, res) => {
    const { cliente_id, funcionario_id, produto_id, descricao, estado, quantidade } = req.body;

    if (!cliente_id || !funcionario_id || !produto_id) {
        return res.status(400).send('Missing required fields: cliente_id, funcionario_id, produto_id');
    }

    const query = 'INSERT INTO pedido (descricao, estado, cliente_id, funcionario_id) VALUES (?, ?, ?, ?)';

    connection.query(query, [descricao, estado, cliente_id, funcionario_id], (err, results) => {
        if (err) {
            console.error('Error running query:', err.stack);
            return res.status(500).send('Error running query');
        }

        // Obtenha o ID do novo item
        const newPedidoId = results.insertId;

        // Agora voc├¬ pode usar o novo ID para inserir itens associados
        const queryItens = 'INSERT INTO produtos_pedidos (pedido_id, produto_id, quantidade) VALUES (?, ?, ?)';

        connection.query(queryItens, [newPedidoId, produto_id, quantidade], (err, results) => {
            if (err) {
                console.error('Error running query for items:', err.stack);
                return res.status(500).send('Error running query for items');
            }

            // Retorne uma resposta de sucesso, incluindo o ID do novo pedido
            res.status(201).json({
                descricao: descricao,
                estado: estado,
                cliente_id: cliente_id,
                funcionario_id: funcionario_id,
                produto_id: produto_id,
                quantidade: quantidade
            });
        });
    });

});
app.get('/tarefa_atribuida', (req, res) => {
    const query = 'SELECT * FROM atribuicao_tarefa';

    connection.query(query, (err, results) => {
        if (err) {
            console.error('Error running query:', err.stack);
            res.status(500).send('Error running query');
            return;
        }
        res.json(results);
    });
});


app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}/`);
});
