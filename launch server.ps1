

write-host "Running..."

$job =Start-Job -ScriptBlock {
  Set-Location $using:PWD
  Set-location 'frontend-react'
  # npm i 
  # npm update 
  npm start
}

$job2 =Start-Job -ScriptBlock {
  Set-Location $using:PWD
  Set-location "backend-rails_api"
  # bundle install
  shutup # gem install shutup
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
