import * as $ from 'jquery';
import {setGreetingContent} from './greet';
import './index.css';

$(() => {
  setGreetingContent('#greeting');
});
