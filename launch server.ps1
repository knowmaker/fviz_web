

write-host "Running..."

$job =Start-Job -ScriptBlock {
  Set-location 'C:\cw\fviz_web\frontend-react'
  # npm i 
  # npm update 
  npm start
}

$job2 =Start-Job -ScriptBlock {
  Set-location 'C:\cw\fviz_web\backend-rails_api'
  # bundle update
  shutup
  rails s -p 5000        
}

While (Get-Job -State "Running")
{
  $out = Receive-Job -Job $job
  if ($out) {
    write-host $out
  }
  $out2 = Receive-Job -Job $job2  
  if ($out2) {
    write-host $out2
  }
}
