import * as path from 'path';
import * as express from 'express';

const app = express();

app.set('view engine', 'hbs');
app.set('views', path.join(__dirname, '/views'));

app.get('/', function(req, res) {
  res.render('index', {
    title: 'Hey',
    message: 'Hello there!',
    todos: [ { id: 1, desc: 'Buy food' }, { id: 2, desc: 'Homework' },
      { id: 3, desc: 'Play video games' } ]
  });
});

app.listen(8080, () => console.log('API is listening on port 8080'));
