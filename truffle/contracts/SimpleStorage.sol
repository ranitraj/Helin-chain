// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract SimpleStorage {
  uint256 value;

  function read() public view returns (uint256) {
    return value;
  }

  function write(uint256 newValue) public {
    value = newValue;
  }
}

contract Helin {
  struct Hospital{
  address hospitalId;
  string hospitalName;
  uint128 departmentId;
  string departmentName;
  }

  struct Insuarance {
  address insuaranceId;
  uint128 policyId;
  string insuaranceName;
  string policyName;
}

  struct Bill {
    address patientId;
    uint128 billAmount;
    uint256 timeAdded;
    Hospital hospital;
  }

  struct Patient {
    address patientId;
    string patientName;
    Insuarance[] insuarances;
    Bill[] bills;
  }


  mapping (address => Patient) public patients;
  mapping (address => Bill) public bills;
  mapping (address => Hospital) public hospitals;
  mapping (address => Insuarance) public insuarances;

  event PatientAdded(address patientId);
  event InsuaranceAdded(address insuaranceId);
  event HospitalAdded(address hospitalId);
  event BillAdded(address patientId);
  event InsuaranceAdded(address insuaranceId, address patientId);


  modifier senderExists {
    require(hospitals[msg.sender].hospitalId == msg.sender || patients[msg.sender].patientId == msg.sender, "sender does not exist");
    _;
  }

  modifier senderIsInsuarance {
    require(insuarances[msg.sender].insuaranceId == msg.sender, "Sender is not a an Insuarance");
    _;
  }

  modifier senderIsPatient {
    require(patients[msg.sender].patientId == msg.sender, "Sender is not a patient");
    _;
  }

  modifier senderIsHospital {
    require(hospitals[msg.sender].hospitalId == msg.sender, "Sender is not Hospital");
    _;
  }

  function addPatient(address _patientId) public senderIsHospital {
    require(patients[_patientId].patientId != _patientId, "This patient already exists.");
    patients[_patientId].patientId = _patientId;
    emit PatientAdded(_patientId);
  }

  function addInsuarance(address _insuaranceId) public senderIsPatient {
    require(insuarances[_insuaranceId].insuaranceId != _insuaranceId, "This insuarance already exists.");
    insuarances[_insuaranceId].insuaranceId = _insuaranceId;
    emit InsuaranceAdded(_insuaranceId);
  }

  function addHospital(address _hospitalId) public {
    require(hospitals[_hospitalId].hospitalId != _hospitalId, "This hospital already exists.");
    patients[_hospitalId].patientId = _hospitalId;
    emit HospitalAdded(_hospitalId);
  }

  function addBillToPatient(address _patientId) public senderIsHospital {
    patients[_patientId].bills.push(bills[_patientId]);
    emit BillAdded(_patientId);
  }

  function addInsuaranceToPatient(address _patientId, address _insuaranceId) public senderIsHospital {
    patients[_patientId].insuarances.push(insuarances[_insuaranceId]);
    emit InsuaranceAdded(_insuaranceId, _patientId);
  }

  function getSenderRole() public view returns (string memory) {
    if (hospitals[msg.sender].hospitalId == msg.sender) {
      return "hospital";
    } else if (patients[msg.sender].patientId == msg.sender) {
      return "patient";
    }
    else if (insuarances[msg.sender].insuaranceId == msg.sender) {
      return "insuarance";
    } else {
      return "unknown";
    }
  }
}