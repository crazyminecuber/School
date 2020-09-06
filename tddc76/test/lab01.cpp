//TODO Ta bort setfill(' ')?
#include <iostream>
#include <iomanip>
#include <string>

using namespace std;

int main()
{
    int integer{};
    string str{};
    float flt{};
    char character{};

    // Sätt inställningar för utmatning av decimaltal.
    cout << setprecision(4) << fixed;

    // Ett heltal
    cout << "Skriv in ett heltal: ";
    cin >> integer;
    cout << "Du skrev in talet: " << integer << "\n\n" << flush;
    cin.ignore(1000, '\n');

    // Fem heltal
    cout << "Skriv in fem heltal: ";
    cin >> integer;
    cout << "Du skrev in talen: " << integer;
    cin >> integer;
    cout << " " << integer;
    cin >> integer;
    cout << " " << integer;
    cin >> integer;
    cout << " " << integer;
    cin >> integer;
    cout << " " << integer << "\n\n" << flush;
    cin.ignore(1000, '\n');

    // Heltal + flyttal
    cout << "Skriv in ett heltal och ett flyttal: ";
    cin >> integer;
    cin >> flt;
    cout <<  left << setw(23) << "Du skrev in heltalet:"
         << right << setw(9)  << integer << endl;
    cout <<  left << setw(23) << "Du skrev in flyttalet:"
         << right << setw(9)  << flt << "\n\n" << flush;
    cin.ignore(1000, '\n');

    // Flyttal + heltal
    cout << "Skriv in ett flyttal och ett heltal: ";
    cin >> flt;
    cin >> integer;
    cout << setfill('-');
    cout << left  << setw(23) << "Du skrev in heltalet:"
         << right << setw(9)  << integer << endl;
    cout << left  << setw(23) << "Du skrev in flyttalet:"
         << right << setw(9)  << flt << "\n\n" << flush;
    cin.ignore(1000, '\n');

    // Tecken
    cout << "Skriv in ett tecken: ";
    cin >> character;
    cout << "Du skrev in tecknet: " << character << "\n\n" << flush;
    cin.ignore(1000, '\n');

    // Ord
    cout << "Skriv in ett ord: ";
    cin >> str;
    cout << "Du skrev in ordet: " << str << "\n\n" << flush;
    cin.ignore(1000, '\n');

    // Heltal + ord
    cout << "Skriv in ett heltal och ett ord: ";
    cin >> integer;
    cin >> str;
    cout << "Du skrev in talet |"
         << integer << "| och ordet |" << str << "|." << "\n\n" << flush;
    cin.ignore(1000, '\n');

    // Tecken + ord
    cout << "Skriv in ett tecken och ett ord: ";
    cin >> character;
    cin >> str;
    cout << "Du skrev in \""
         << str << "\" och \'" << character << "\'." << "\n\n" << flush;
    cin.ignore(1000, '\n');

    // Rad
    cout << "Skriv in en rad text: ";
    getline(cin, str, '\n');
    cout << "Du skrev in: \"" << str << "\"" << "\n\n" << flush;

    // Rad 2
    cout << "Skriv in en till rad text: ";
    getline(cin, str, '\n');
    cout << "Du skrev in: \"" << str << "\"" << "\n\n" << flush;

    // 3 ord
    cout << "Skriv in tre ord: ";
    cin >> str;
    cout << "Du skrev in: \"" << str << "\"";
    cin >> str;
    cout << ", \"" << str << "\"";
    cin >> str;
    cout << " och \"" << str << "\"" << "\n\n" << flush;
    cin.ignore(1000, '\n');

    return 0;
}
