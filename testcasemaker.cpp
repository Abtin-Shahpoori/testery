#include <bits/stdc++.h>

using namespace std;

int main(){
    string TestCase;
    ifstream mn("inputfile.txt");
    int l = 0;
    while (getline(mn, TestCase)){
        l ++;
        short int test_end_position = TestCase.find("->");
        string hlp = "input.";
        hlp += to_string(l);
        hlp += ".in" ;
        ofstream filt(hlp);
        for(int i = 4; i <= test_end_position; i ++){
            if(TestCase[i + 1] == '-' && TestCase[i + 2] == '>'){
                filt << '\n';
                break;
            } else{
                filt << TestCase[i];
            }
        }
        filt.close();
        hlp = "output.";
        hlp += to_string(l);
        hlp += ".out";
        ofstream folt(hlp);
        for(int i = test_end_position + 3; ; i ++){
            if(TestCase[i] == ':'){
                folt << '\n';
                break;
            } else{
                folt << TestCase[i];
            }            
        }
    }
}
