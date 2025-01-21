const app = new Vue({
    el: '#app',
    data: {
        health: 100,
        armor: 0,
        food: 100,
        drink: 100,
        stamina: 100,
        show: true
    },
    watch: {
        armor(newVal) {
            const element = document.getElementById('armor-box');
            element.style.display = newVal > 0 ? 'block' : 'none';
        },
        food(newVal) {
            const element = document.getElementById('food-box');
            element.style.display = newVal < 98 && newVal > 0 ? 'block' : 'none';
        },
        drink(newVal) {
            const element = document.getElementById('drink-box');
            element.style.display = newVal < 98 && newVal > 0 ? 'block' : 'none';
        },
        stamina(newVal) {
            const element = document.getElementById('stamina-box');
            element.style.display = newVal < 98 && newVal > 0 ? 'block' : 'none';
        }
    },
    methods: {
        updateProgress(key, value) {
            this[key] = Math.max(0, Math.min(100, Math.round(value)));
        },
        
        updateHUD(data) {
            this.updateProgress('health', data.health);
            this.updateProgress('armor', data.shield);
            this.updateProgress('food', data.hunger);
            this.updateProgress('drink', data.thirst);
            this.updateProgress('stamina', data.stamina);
        }
    },
    mounted() {
        document.getElementById('armor-box').style.display = 'none';
        document.getElementById('food-box').style.display = 'none';
        document.getElementById('drink-box').style.display = 'none';
        document.getElementById('stamina-box').style.display = 'none';

        window.addEventListener('message', (event) => {
            const data = event.data;

            if (data.type === 'updateHUD') {
                this.updateHUD(data);
            } else if (data.type === 'show') {
                this.show = data.status;
            }
        });
    }
});