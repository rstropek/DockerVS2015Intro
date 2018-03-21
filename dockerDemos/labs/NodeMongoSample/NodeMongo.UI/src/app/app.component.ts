import {HttpClient} from '@angular/common/http';
import {Component, OnInit} from '@angular/core';
import { IEvent, IParticipant } from './model';
import { Observable } from 'rxjs/Observable';

@Component({
  selector: 'app-root', 
  templateUrl: 'app.component.html', 
  styles: []})
export class AppComponent implements OnInit {
  constructor(private http: HttpClient) {}

  public events: Observable<IEvent[]>;

  ngOnInit(): void {
    this.events = this.http.get<IEvent[]>('http://localhost:1337/api/events?past=true');
  }
}
