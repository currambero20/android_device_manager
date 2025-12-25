import { Toaster } from "@/components/ui/sonner";
import { TooltipProvider } from "@/components/ui/tooltip";
import NotFound from "@/pages/NotFound";
import { Route, Switch } from "wouter";
import ErrorBoundary from "./components/ErrorBoundary";
import { ThemeProvider } from "./contexts/ThemeContext";
import Home from "./pages/Home";
import Dashboard from "./pages/Dashboard";
import Devices from "./pages/Devices";
import Users from "./pages/Users";
import Permissions from "./pages/Permissions";
import ApkBuilder from "./pages/ApkBuilder";
import AuditLogs from "./pages/AuditLogs";
import Settings from "./pages/Settings";
import DeviceMonitoring from "./pages/DeviceMonitoring";
import RemoteControl from "./pages/RemoteControl";
import Analytics from "./pages/Analytics";
import Geofencing from "./pages/Geofencing";
import Notifications from "./pages/Notifications";
import AdvancedMonitoring from "./pages/AdvancedMonitoring";
import PermissionsManagement from "./pages/PermissionsManagement";
import FileExplorer from "./pages/FileExplorer";
import AppManager from "./pages/AppManager";
import DeviceMap from "./pages/DeviceMap";

function Router() {
  return (
    <Switch>
      <Route path={"/"} component={Home} />
      
      {/* Dashboard Routes */}
      <Route path={"/dashboard"} component={Dashboard} />
      <Route path={"/devices"} component={Devices} />
      <Route path={"/users"} component={Users} />
      <Route path={"/permissions"} component={Permissions} />
      <Route path={"/apk-builder"} component={ApkBuilder} />
      <Route path={"/audit-logs"} component={AuditLogs} />
      <Route path={"/settings"} component={Settings} />
      <Route path={"/monitoring"} component={DeviceMonitoring} />
      <Route path={"/remote-control"} component={RemoteControl} />
      <Route path={"/analytics"} component={Analytics} />
      <Route path={"/geofencing"} component={Geofencing} />
      <Route path={"/notifications"} component={Notifications} />
      <Route path="/advanced-monitoring" component={AdvancedMonitoring} />
      <Route path="/permissions-management" component={PermissionsManagement} />
      <Route path="/file-explorer" component={FileExplorer} />
      <Route path="/app-manager" component={AppManager} />
      <Route path="/device-map" component={DeviceMap} />
      <Route path="/404" component={NotFound} />
      {/* Final fallback route */}
      <Route component={NotFound} />
    </Switch>
  );
}

function App() {
  return (
    <ErrorBoundary>
      <ThemeProvider
        defaultTheme="dark"
      >
        <TooltipProvider>
          <Toaster />
          <Router />
        </TooltipProvider>
      </ThemeProvider>
    </ErrorBoundary>
  );
}

export default App;
