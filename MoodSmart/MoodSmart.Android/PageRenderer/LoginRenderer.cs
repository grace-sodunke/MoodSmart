using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using Android.App;
using Android.Content;
using Android.OS;
using Android.Runtime;
using Android.Views;
using Android.Widget;

using MoodSmart;
using Xamarin.Forms.Platform.Android;
using MoodSmart.Droid.PageRenderer;
using Xamarin.Forms;
using Xamarin.Auth;
using Newtonsoft.Json;
using Java.Util;
using Firebase.Database;
using MoodSmart.Droid.Helpers;

[assembly: ExportRenderer(typeof(ProviderLoginPage), typeof(LoginRenderer))]
namespace MoodSmart.Droid.PageRenderer
{
    public class LoginRenderer : Xamarin.Forms.Platform.Android.PageRenderer
    {
        public LoginRenderer(Context context) : base(context) { }

        bool showLogin = true;
        protected override void OnElementChanged(ElementChangedEventArgs<Page> e)
        {
            base.OnElementChanged(e);

            //Get and Assign ProviderName from ProviderLoginPage            
            var loginPage = Element as ProviderLoginPage;
            string providername = loginPage.ProviderName;

            var activity = this.Context as Activity;
            if (showLogin && OAuthConfig.User == null)
            {
                showLogin = false;

                //Oauth implementation
                OAuthProviderSetting oauth = new OAuthProviderSetting();

                if (providername == "Twitter")
                {
                    var auth = oauth.LoginWithTwitter();
                    // After Twitter  login completed 
                    auth.Completed += TwitterAuth_Completed;
                    activity.StartActivity(auth.GetUI(activity));
                }                
            }
        }
        async void TwitterAuth_Completed(object sender, AuthenticatorCompletedEventArgs e)
        {            
            
            if (e.IsAuthenticated)
            {
                var request = new OAuth1Request("GET",
                               new Uri("https://api.twitter.com/1.1/account/verify_credentials.json"),
                               null,
                               e.Account);

                var response = await request.GetResponseAsync();

                var json = response.GetResponseText();

                OAuthConfig.TwitterUser = JsonConvert.DeserializeObject<TwitterUser>(json);

                FirebaseHelper firebaseHelper = new FirebaseHelper();
                firebaseHelper.CreateUser();
                
                /*
                HashMap twitterUser = new HashMap();
                twitterUser.Put("id", OAuthConfig.TwitterUser.id);
                twitterUser.Put("id_str", OAuthConfig.TwitterUser.id_str);
                twitterUser.Put("name", OAuthConfig.TwitterUser.name);
                twitterUser.Put("screen_name", OAuthConfig.TwitterUser.screen_name);
                twitterUser.Put("location", OAuthConfig.TwitterUser.location);
                twitterUser.Put("description", OAuthConfig.TwitterUser.description);
                twitterUser.Put("url", OAuthConfig.TwitterUser.url);
                twitterUser.Put("@protected", OAuthConfig.TwitterUser.@protected);

                DatabaseReference newTwitterUser = AppDataHelper.GetDatabase().GetReference("twitter_user").Push();
                newTwitterUser.SetValue(twitterUser);
                */

                /*
                OAuthConfig.User = new UserDetails();
                // Get and Save User Details 

                OAuthConfig.User.TokenSecret = e.Account.Properties["oauth_token_secret"];
                OAuthConfig.User.TwitterId = e.Account.Properties["user_id"];
                OAuthConfig.User.ScreenName = e.Account.Properties["screen_name"];
                */

                OAuthConfig.SuccessfulLoginAction.Invoke();                
            }
            else
            {
                // The user cancelled
            }            
        }
    }
}

/* NEXT STEPS
 * Once authenticated, save their new account to Firebase database (if isn't there already)
 * Test: Open up dashboard page and get the account name not through the TwitterUser class, but through an API call to Firebase.
 * The above test will allow me to test how I'm able to put and retrieve information.
 * Now that user account authentication and creation is handled (later I need to think about how to sign out or sign out and delete your account),
 * I need to perform this: get past user tweets over a week (or any suitable time period for testing), perform sentiment analysis by requesting the model,
 * then store the PREDICTIONS and not the tweets in Firebase (each row in the database table is a week, and each column is the prediction value and tweet metadata
 * with it).
 * Once I'm able to reliably predict tweets and then store this data in the user's Firebase entry, I can NOW create a class where I calculate how to generate the
 * weekly reports using the record of tweet predictions. This weekly report class can be stored in Firebase each week its generated (it will be the last column in 
 * the row for that week). The latest weekly report will be retrieved from Firebase and loaded into the dashboard whenever the user opens the app.
 * To Consider Later: I'm not sure if you need to have an internet connection to get data from Firebase, but if so, I can now look at using SQLite to store the latest
 * user info inside the app instead of having to rely on a service each time. This can improve performance
 * FINALLY NOW I'm able to make a pretty UI!! (To get to this stage sooner I may have to skip the SQLite step)
 */