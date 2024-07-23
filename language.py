import random

consonents = ["m","n","ng","p","b","t","d","k","g","f","v","th","dh","s","z","sh","zh","ch","dj","h","w","l","r","j",]
vowels = ["i_","u_","o_","aw","uh","a_","e_","ih","oi","ai","ei","au",]
punctuation = [" ",".",",","?","!",] 

def generate_all_combinations():
    out = ""
    for c in [""] + consonents:
        for v in [""] + vowels:
            out += c + v
        print(out)
        out = ""
            

def generate_random():
    for i in range(20):
        print("".join([random.choice(consonents + vowels + punctuation) for i in range(100)]))

if __name__ == "__main__":
    # generate_random()
    generate_all_combinations()
