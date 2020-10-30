#include <iostream>
#include <iomanip>

using namespace std;

int getCelcius(string const & askPhrase);
float celciusToKelvin(int celcius);
float celciusToFarenheit(int celcius);
float celciusToReaumur(int celcius);

int main()
{
    int celciusLow{};
    int celciusHigh{};

    cout << setprecision(2) << fixed << left;
    celciusLow = getCelcius("Ange startvärde:");
    celciusHigh = getCelcius("Ange slutvärde:");

    while(celciusLow >= celciusHigh)
    {
        cout << "Felaktig inmatning!" << endl;
        celciusHigh = getCelcius("Ange slutvärde:");
    }

    // Avänd högerformattering i tabellen.
    cout << right << endl;
    cout << setw(7)  << "Celcius"
         << setw(11) << "Kelvin"
         << setw(11) << "Farenheit"
         << setw(11) << "Reaumur" << endl;
    cout << setw(40) << setfill('-') << "-" << endl;

    // Skriv ut tabellen med ' ' som filler.
    cout<< setfill(' ');
    for(int i{celciusLow}; i<=celciusHigh; i++)
    {
        cout << setw(7)  << i
             << setw(11) << celciusToKelvin(i)
             << setw(11) << celciusToFarenheit(i)
             << setw(11) << celciusToReaumur(i) << endl;
    }

    return 0;
}

/*
 * Skriver ut askPhrase som ber användaren om input. Kontrollerar om input är
 * en korrekt temperatur. Annars frågas användaren igen.
 */
int getCelcius(string const & askPhrase)
{
    int celcius{};
    cout << setw(20) << askPhrase;

    // Väntar på att användaren anger en korrekt temperatur.
    while(!(cin >> celcius) || celcius < -273)
    {
        cin.clear();
        cin.ignore(1000, '\n');
        cout << "Felaktig inmatning!" << endl;
        cout <<  left << setw(20) << setfill(' ') << askPhrase;
    }
    cin.ignore(1000, '\n');
    return celcius;
}

float celciusToKelvin(int celcius)
{
    return celcius + 273.15;
}

float celciusToFarenheit(int celcius)
{
    return celcius * 9.0 / 5 + 32;
}

float celciusToReaumur(int celcius)
{
    return celcius * 4.0 / 5;
}
