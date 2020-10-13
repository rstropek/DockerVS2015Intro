package main

import (
	"encoding/json"
	"errors"
	"fmt"
	"log"
	"net/http"
	"os"
	"strconv"
	"sync/atomic"

	"github.com/gorilla/handlers"
	"github.com/gorilla/mux"
)

type lunchOrder struct {
	ID     uint64 `json:"id,omitempty"`
	Day    byte   `json:"day"`
	Person string `json:"person"`
	MealID uint16 `json:"mealId"`
	Notes  string `json:"notes"`
}

func (lo *lunchOrder) isValid() error {
	switch {
	case len(lo.Person) == 0:
		return errors.New("Person must be set")
	case lo.Day > 6:
		return errors.New("Day must be between 0 (Monday) and 6 (Sunday)")
	case lo.MealID < 1 || lo.MealID > 6:
		return errors.New("Invalid meal id")
	default:
		return nil
	}
}

type meal struct {
	ID    uint64  `json:"id,omitempty"`
	Desc  string  `json:"desc"`
	Price float32 `json:"price"`
}

var meals = [...]meal{
	{ID: 1, Desc: "Spaghetti Pomodoro", Price: 5.90},
	{ID: 2, Desc: "Wiener Schnitzel", Price: 8.50},
	{ID: 3, Desc: "Pizza Speciale", Price: 7.20},
	{ID: 4, Desc: "Griechischer Salat", Price: 5.30},
	{ID: 5, Desc: "Gemüsesuppe", Price: 2.10},
	{ID: 6, Desc: "Frittatensuppe", Price: 2.10},
}
var orders = []lunchOrder{
	{ID: 1, Day: 0, Person: "Tom", MealID: 1, Notes: "Mit viel Parmesan"},
	{ID: 2, Day: 1, Person: "Tom", MealID: 2},
	{ID: 3, Day: 2, Person: "Tom", MealID: 4, Notes: "Ohne Zwiebel"},
	{ID: 4, Day: 2, Person: "Tom", MealID: 5},
	{ID: 5, Day: 3, Person: "Tom", MealID: 3},
	{ID: 6, Day: 4, Person: "Tom", MealID: 6},
	{ID: 7, Day: 0, Person: "Jane", MealID: 2, Notes: "Kartoffel statt Pommes"},
	{ID: 8, Day: 1, Person: "Jane", MealID: 3},
	{ID: 9, Day: 2, Person: "Jane", MealID: 5},
	{ID: 10, Day: 2, Person: "Jane", MealID: 6},
	{ID: 11, Day: 3, Person: "Jane", MealID: 1},
	{ID: 12, Day: 4, Person: "Jane", MealID: 4, Notes: "Ohne Oliven"},
}
var id uint64 = 12

// our main function
func main() {
	var port uint16 = 8080
	args := os.Args[1:]
	if len(args) > 0 {
		argsPort, convErr := strconv.ParseUint(args[0], 10, 16)
		if convErr != nil {
			fmt.Fprintf(os.Stderr, "%s is not a valid port number", args[0])
			return
		}

		port = uint16(argsPort)
	} else {
		fmt.Printf("No port given in command line, using default (%d).\n", port)
	}

	headersOk := handlers.AllowedHeaders([]string{"X-Requested-With", "Content-Type", "Authorization"})
	originsOk := handlers.AllowedOrigins([]string{"*"})
	methodsOk := handlers.AllowedMethods([]string{"GET", "HEAD", "POST", "PUT", "OPTIONS"})

	router := mux.NewRouter()
	router.HandleFunc("/api/ping", getPing).Methods("GET")
	router.HandleFunc("/api/meals", getMeals).Methods("GET")
	router.HandleFunc("/api/lunchOrders", getLunchOrders).Methods("GET")
	router.HandleFunc("/api/lunchOrders/{id}", getLunchOrder).Methods("GET")
	router.HandleFunc("/api/lunchOrders", addLunchOrder).Methods("POST")
	fmt.Printf("Server starting, will listen to port %d...\n", port)
	log.Fatal(http.ListenAndServe(fmt.Sprintf(":%d", port), handlers.CORS(originsOk, headersOk, methodsOk)(router)))
}

func writeError(sc int, err error, w http.ResponseWriter, enc *json.Encoder) {
	w.WriteHeader(sc)
	enc.Encode(map[string]string{"error": err.Error()})
}

func getPing(w http.ResponseWriter, r *http.Request) {
	json.NewEncoder(w).Encode("Pong")
}

func getMeals(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(meals)
}

func getLunchOrders(w http.ResponseWriter, r *http.Request) {
	queryValues := r.URL.Query()
	person := queryValues.Get("person")
	filtered := len(person) != 0
	result := []lunchOrder{}
	for _, order := range orders {
		if !filtered || order.Person == person {
			result = append(result, order)
		}
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(result)
}

func getLunchOrder(w http.ResponseWriter, r *http.Request) {
	// content type will always be json
	w.Header().Set("Content-Type", "application/json")

	// create an encoder for writing response
	enc := json.NewEncoder(w)

	// check whether ID is present
	params := mux.Vars(r)
	paramIDStr, prs := params["id"]
	if !prs {
		writeError(http.StatusBadRequest, errors.New("Missing id"), w, enc)
		return
	}

	// try to parse ID as an int
	paramID, convErr := strconv.ParseUint(paramIDStr, 10, 64)
	if convErr != nil {
		writeError(http.StatusBadRequest, convErr, w, enc)
		return
	}

	// search for order based on ID
	for _, item := range orders {
		if item.ID == paramID {
			// we have found the order based on ID
			w.WriteHeader(http.StatusOK)
			enc.Encode(item)
			return
		}
	}

	w.WriteHeader(http.StatusNotFound)
}

func addLunchOrder(w http.ResponseWriter, r *http.Request) {
	// content type will always be json
	w.Header().Set("Content-Type", "application/json")

	// resulting order struct
	var order lunchOrder

	// create an encoder for writing response
	enc := json.NewEncoder(w)

	// decode incoming json from body
	err := json.NewDecoder(r.Body).Decode(&order)
	if err != nil {
		writeError(http.StatusBadRequest, err, w, enc)
		return
	}

	// Validate order
	if err = order.isValid(); err != nil {
		writeError(http.StatusBadRequest, err, w, enc)
		return
	}

	// increment unique order id counter and add it to order
	atomic.AddUint64(&id, 1)
	order.ID = atomic.LoadUint64(&id)

	// add order to orders
	orders = append(orders, order)

	// return success
	w.Header().Set("Location", fmt.Sprintf("/lunchOrders/%d", order.ID))
	w.WriteHeader(http.StatusCreated)
	enc.Encode(order)
}