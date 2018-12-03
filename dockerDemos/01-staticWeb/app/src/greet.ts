import * as $ from 'jquery';

export function setGreetingContent(id: string): void {
  $(id).text('Hello World!');
}
