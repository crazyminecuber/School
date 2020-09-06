#include <iostream>
#include <string>
using namespace std;
int main()
{
	cout << "Hello world!" << endl;
	// int x{7};
	string str{};
	/*cin >> x;
	cout << x << endl;
	cout << str << endl;*/
	//char name[25];
    // cin.get(name, 25);
	//
	float temp;
	if ( std::cin >> temp )
	{
		cout << "Du matade in temperaturen " << temp << endl;
	}
	else
	{
		cout << "Tyvärr, du matade inte in ett giltigt heltal";
		cin.clear(); // Reparera
		cin.ignore(1000, '\n'); // Undvik nytt fel
	}

	cin >> str;
	//char name[25];
    //cin.get(name, 25);
	cout << str << endl;
	int x{0};
	do
	{
		x++;
		cout << x << endl;
	}
	while ( x < 5 );

	int funktion(int gurka);


	funktion(x);

	return 0;


}

int funktion(string &gurka)
{
	return 1;
}
