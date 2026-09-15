#include <iostream>
#include <fstream>
#include <cstring>
using namespace std;

struct Student {
    int SID;
    char NAME[50];
    char BRANCH[20];
    int SEMESTER;
    char ADDRESS[100];
};

// Display one student
void display(Student s) {
    cout << "\nSID      : " << s.SID;
    cout << "\nName     : " << s.NAME;
    cout << "\nBranch   : " << s.BRANCH;
    cout << "\nSemester : " << s.SEMESTER;
    cout << "\nAddress  : " << s.ADDRESS << endl;
}

// a. Insert a new student
void insertStudent() {
    Student s;

    cout << "\nEnter SID: ";
    cin >> s.SID;

    cout << "Enter Name: ";
    cin.ignore();
    cin.getline(s.NAME, 50);

    cout << "Enter Branch: ";
    cin.getline(s.BRANCH, 20);

    cout << "Enter Semester: ";
    cin >> s.SEMESTER;

    cout << "Enter Address: ";
    cin.ignore();
    cin.getline(s.ADDRESS, 100);

    ofstream file("students.dat", ios::binary | ios::app);

    file.write((char*)&s, sizeof(s));
    file.close();

    cout << "\nStudent inserted successfully!\n";
}

// b. Modify address based on SID
void modifyAddress() {
    int sid;
    bool found = false;

    cout << "\nEnter SID: ";
    cin >> sid;

    fstream file("students.dat", ios::binary | ios::in | ios::out);

    Student s;

    while (file.read((char*)&s, sizeof(s))) {
        if (s.SID == sid) {
            cout << "Enter new address: ";
            cin.ignore();
            cin.getline(s.ADDRESS, 100);

            // Move file pointer back by one record
            file.seekp(-sizeof(s), ios::cur);

            file.write((char*)&s, sizeof(s));

            found = true;
            break;
        }
    }

    file.close();

    if (found)
        cout << "\nAddress modified successfully!\n";
    else
        cout << "\nStudent not found!\n";
}

// c. Delete a student
void deleteStudent() {
    int sid;
    bool found = false;

    cout << "\nEnter SID to delete: ";
    cin >> sid;

    ifstream file("students.dat", ios::binary);
    ofstream temp("temp.dat", ios::binary);

    Student s;

    while (file.read((char*)&s, sizeof(s))) {
        if (s.SID == sid) {
            found = true;
            continue;       // Don't write this student
        }

        temp.write((char*)&s, sizeof(s));
    }

    file.close();
    temp.close();

    remove("students.dat");
    rename("temp.dat", "students.dat");

    if (found)
        cout << "\nStudent deleted successfully!\n";
    else
        cout << "\nStudent not found!\n";
}

// d. List all students
void listAll() {
    ifstream file("students.dat", ios::binary);

    Student s;
    bool empty = true;

    cout << "\n===== ALL STUDENTS =====\n";

    while (file.read((char*)&s, sizeof(s))) {
        display(s);
        empty = false;
    }

    file.close();

    if (empty)
        cout << "No students found.\n";
}

// e. List all CSE students
void listCSE() {
    ifstream file("students.dat", ios::binary);

    Student s;
    bool found = false;

    cout << "\n===== CSE STUDENTS =====\n";

    while (file.read((char*)&s, sizeof(s))) {
        if (strcmp(s.BRANCH, "CSE") == 0) {
            display(s);
            found = true;
        }
    }

    file.close();

    if (!found)
        cout << "No CSE students found.\n";
}

// f. List CSE students residing in Kuvempunagar
void listCSEKuvempunagar() {
    ifstream file("students.dat", ios::binary);

    Student s;
    bool found = false;

    cout << "\n===== CSE STUDENTS IN KUVEMPUNAGAR =====\n";

    while (file.read((char*)&s, sizeof(s))) {
        if (strcmp(s.BRANCH, "CSE") == 0 &&
            strcmp(s.ADDRESS, "Kuvempunagar") == 0) {

            display(s);
            found = true;
        }
    }

    file.close();

    if (!found)
        cout << "No matching students found.\n";
}

// Main menu
int main() {
    int choice;

    do {
        cout << "\n\n===== STUDENT DATABASE =====";
        cout << "\n1. Insert a new student";
        cout << "\n2. Modify address";
        cout << "\n3. Delete a student";
        cout << "\n4. List all students";
        cout << "\n5. List all CSE students";
        cout << "\n6. List CSE students in Kuvempunagar";
        cout << "\n7. Exit";

        cout << "\n\nEnter your choice: ";
        cin >> choice;

        switch (choice) {
            case 1:
                insertStudent();
                break;

            case 2:
                modifyAddress();
                break;

            case 3:
                deleteStudent();
                break;

            case 4:
                listAll();
                break;

            case 5:
                listCSE();
                break;

            case 6:
                listCSEKuvempunagar();
                break;

            case 7:
                cout << "\nExiting program...\n";
                break;

            default:
                cout << "\nInvalid choice!\n";
        }

    } while (choice != 7);

    return 0;
}
