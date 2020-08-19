using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xamarin.Forms;
using Xamarin.Auth;
using Newtonsoft.Json;

namespace MoodSmart
{
    // Learn more about making custom code visible in the Xamarin.Forms previewer
    // by visiting https://aka.ms/xamarinforms-previewer
    [DesignTimeVisible(false)]
    public partial class MainPage : ContentPage
    {
        public MainPage()
        {
            InitializeComponent();
        }

        /*private async void TwitterAuth (object sender, EventArgs args) {
            var auth = new OAuth1Authenticator(
                consumerKey = "UNsEOEtHtrJ6bePIt1dIXJqz8",
                consumerSecret = "J13UIgk0j9IrTDfU2ZOdyQ1L2BdhblMqqMiCoj7Qicm9igK01e",
                requestTokenUrl = new Uri("https://api.twitter.com/oauth/request_token"),
                authorizeUrl = new Uri("https://api.twitter.com/oauth/authorize"),
                accessTokenUrl = new Uri("https://api.twitter.com/oauth/access_token"),
                callbackUrl = new Uri("http://mobile.twitter.com/home")
            );
            auth.AllowCancel = true;
            //I'VE FINALLY FOUND HOW TO IMPLEMENT OAUTH WITH TWITTER (AND EVEN OTHER PROVIDERS)
            //URL: https://www.c-sharpcorner.com/article/oauth-login-authenticating-with-identity-provider-in-xamarin-forms/
            //Now need to look at how user data is stored in persistent storage once they log in (Firebase, SQLite, Azure?)
            //Also where to host machine learning models?
            //Callback Url isnt https://moodsmart-e2625.firebaseapp.com/__/auth/handler
            auth.Completed += (s, eventArgs) => 
            {
                this.DismissViewController(true, null);
                System.Diagnostics.Debug.WriteLine("Is user authenticated" + eventArgs.IsAuthenticated);

                if (eventArgs.IsAuthenticated)
                {
                    System.Diagnostics.Debug.WriteLine("Method should be invoked.");
                    App.Instance.SaveToken(eventArgs.Account.Properties["oauth_token"]);
                    Account loggedInAccount = eventArgs.Account;
                    //Save the account data for a later session, according to Twitter docs, this doesn't expire
                    AccountStore.Create(this).Save(loggedInAccount, "Twitter");
                }
            };
            PresentViewController(auth.GetUI(), true, null); //This probably shouldn't be on top of the Completed event handling
        }*/
    }
}
