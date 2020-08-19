using MoodSmart.Pages;
using System;
using System.Collections.Generic;
using System.Text;
using Xamarin.Forms;

namespace MoodSmart
{
    public class OAuthConfig
    {
        //public static LoginPage _LoginPage;
        public static Dashboard _Dashboard;
        static NavigationPage _NavigationPage; //Probably don't need this, brings up an error
        public static UserDetails User;
        public static TwitterUser TwitterUser;
        //public static INavigation Navigation;


        public static Action SuccessfulLoginAction
        {
            get
            {
                return new Action(() =>
                {
                    //Perform GET request for user twitter account details , display them on the page to test (will eventually store in backend database)
                    //(Application.Current as App).MainPage.Navigation.PushAsync(new Dashboard());
                    //Navigation.PushAsync(new Dashboard());
                    //_NavigationPage.Navigation.PushModalAsync(new Dashboard);

                    //int index = Application.Current.MainPage.Navigation.NavigationStack.Count - 1;
                    Page currentPage = App.Current.MainPage; //Application.Current.MainPage.Navigation.NavigationStack[index];
                    currentPage.Navigation.PushModalAsync(new NavigationPage(new Dashboard())); //This works!!

                    // *** NOW NEED TO SAVE TWITTER USER DETAILS TO A DATABASE AND RETRIEVE THEM IN THE DASHBOARD PAGE ***
                });
            }
        }
    }
}
