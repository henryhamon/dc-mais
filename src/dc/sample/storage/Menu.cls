Class dc.sample.storage.Menu Extends %RegisteredObject
{

ClassMethod Get() As %DynamicObject
{
    Return {
            "appetizers": [
                {"id": 1, "name": "Bruschetta", "price": 8.50, "description": "Toasted Italian bread with tomato, basil and extra virgin olive oil"},
                {"id": 2, "name": "Escargot", "price": 12.00, "description": "Provençal snails with garlic, butter and herbs"},
                {"id": 3, "name": "Cheese Board", "price": 15.50, "description": "Selection of artisanal cheeses with jams and walnuts"}
            ],
            "main_courses": [
                {"id": 4, "name": "Coq au Vin", "price": 28.00, "description": "Chicken braised in red wine with mushrooms and bacon"},
                {"id": 5, "name": "Boeuf Bourguignon", "price": 32.00, "description": "Beef stew in wine with vegetables"},
                {"id": 6, "name": "Grilled Salmon", "price": 26.00, "description": "Grilled salmon fillet with lemon sauce and asparagus"},
                {"id": 7, "name": "Ratatouille", "price": 22.00, "description": "Provençal vegetables au gratin (vegetarian option)"}
            ],
            "desserts": [
                {"id": 8, "name": "Crème Brûlée", "price": 9.00, "description": "Vanilla custard with caramelized sugar"},
                {"id": 9, "name": "Tarte Tatin", "price": 10.00, "description": "Upside-down caramelized apple tart"},
                {"id": 10, "name": "Chocolate Mousse", "price": 8.50, "description": "Belgian 70% cocoa chocolate mousse"}
            ],
            "beverages": [
                {"id": 11, "name": "House Red Wine", "price": 18.00, "description": "Glass of selected red wine"},
                {"id": 12, "name": "House White Wine", "price": 18.00, "description": "Glass of selected white wine"},
                {"id": 13, "name": "Sparkling Water", "price": 4.00, "description": "Sparkling mineral water 16.9oz"},
                {"id": 14, "name": "Fresh Juice", "price": 7.00, "description": "Fresh juice of the day"}
            ],
            "extras": [
                {"name": "Extra Bread", "price": 2.00},
                {"name": "Extra Sauce", "price": 1.50},
                {"name": "Side Salad", "price": 5.00},
                {"name": "French Fries", "price": 6.00}
                ]
            }
}

}
