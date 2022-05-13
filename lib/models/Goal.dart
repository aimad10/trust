class Goal
{ 
  //parameters that goals have 
  int id;
  String name;
  String description;
  int amount;
  String date;

  Goal(this.name, this.amount, this.date, [this.description]); //add them to keys
  Goal.withId(this.id, this.name, this.amount, this.date, [this.description]); //weird flutter 1 language, if it has an ID then use this?

  Map<String, dynamic> toMap() 
  {
    return 
    {
      'id': id, 
      'name': name,
      'amount': amount,
      'date': date,
      'description': description,
    };
  }

  Goal.fromMapObject(Map<String, dynamic> map) 
  {
		this.id = map['id'];
		this.amount = map['amount'];
		this.description = map['description'];
		this.name = map['name'];
		this.date = map['date'];
	}

  @override
  String toString()  //return all of them as strings
  {
    return 'Goal{id: $id, name: $name, description: $description, amount: $amount, date: $date}';
  }
}