using System;
using System.Collections.Generic;
using System.Text;
using MoodSmart.Pages;
using Firebase.Database;
using Firebase.Database.Query;
using System.Linq;
using System.Threading.Tasks;
using Newtonsoft.Json;
using Xamarin.Forms;

namespace MoodSmart
{
    public class FirebaseHelper
    {
        FirebaseClient firebase = new FirebaseClient("https://moodsmart-e2625.firebaseio.com");

        public async Task CreateUser()
        {
            var newUser = await firebase
                .Child("twitter_user")
                .PostAsync(OAuthConfig.TwitterUser);
            //var userNamesRef = newUser.Key;//firebase.GetReference(User.UserNameRoot);
            //var userNamesRef = firebase.GetInstance(firebaseURL).GetReference(User.UserNameRoot);
            Application.Current.Properties.Add("key", newUser.Key);
            await Application.Current.SavePropertiesAsync();
        }
        public async Task<string> temp_getName()
        {
            string key = Application.Current.Properties["key"] as string;
            //string key_name = key.Select(c => c.ToString());
            string name = await firebase
                .Child("twitter_user")//I can't get the child key by storing the key and retrieving it from properties. I need to research more - database ref? A lot of articles on my phone
                .Child(key)
                .Child("name")                
                .OnceAsync<string>();
            return name;
        } //Need to either figure out a way to add elements without generating a scrambled key, or ??? ordering by a child element and adding an index security rule?
    }
}
