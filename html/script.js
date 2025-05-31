document.addEventListener('DOMContentLoaded', function() {
    const spawnBtns = document.querySelectorAll('.spawn-btn');
    const closeBtn = document.querySelector('.close-btn');
    
    // Listen for messages from the game client
    window.addEventListener('message', function(event) {
        if (event.data.type === "toggle") {
            if (event.data.status) {
                document.body.classList.add('active');
            } else {
                document.body.classList.remove('active');
            }
        }
    });

    // Handle ESC key
    document.addEventListener('keyup', function(event) {
        if (event.key === "Escape") {
            fetch(`https://${GetParentResourceName()}/closeUI`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({})
            });
        }
    });
    
    // Handle close button click
    closeBtn.addEventListener('click', function() {
        fetch(`https://${GetParentResourceName()}/closeUI`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({})
        });
    });
    
    spawnBtns.forEach(btn => {
        btn.addEventListener('click', function() {
            const vehicleType = this.getAttribute('data-vehicle');
            fetch(`https://${GetParentResourceName()}/spawnVehicle`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    vehicle: vehicleType
                })
            });
        });
    });
}); 