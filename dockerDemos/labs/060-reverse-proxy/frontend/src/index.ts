import './index.scss';

interface IMeal {
    id: number;
    desc: string;
    price: string;
}

(async () => {
    const mealsElement = document.getElementById('meals') as HTMLUListElement;

    const response = await fetch("/api/meals");
    const meals = (await response.json()) as IMeal[];

    for (let meal of meals) {
        const li = document.createElement('li');
        li.innerText = `${meal.desc} for ${meal.price}`;
        mealsElement.appendChild(li);
    }
})();
